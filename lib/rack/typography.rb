require 'rack'
require 'rubypants'
# = Typography Cleaner for Rack
#
# Rack::Typography cleans a text/html response by automatically 
# encoding ampersands, apostrophes, quotes, dashes, and ellipses
# as well as handling widows.
#
# === Usage
#
# Within a rackup file (or with Rack::Builder):
#   require 'rack/typography'
#   use Rack::Typography,
#     :ignore_paths => ['/admin', '/cms'],
#     'indent-spaces' => 4
#   run app
#
# Rails example:
#   # above Rails::Initializer block
#   require 'rack/typography'
#
#   # inside Rails::Initializer block 
#   config.middleware.use Rack::Typography,
#     :ignore_paths => ['/admin', '/cms']
class Rack::Typography
  VERSION = '0.1'

  # Paths to be ignored during processing
  attr_accessor :ignore_paths

  def initialize(app, options = {})
    @app = app
    self.ignore_paths = options[:ignore_paths] || []
  end

  # method required by Rack interface
  def call(env)
    call! env
  end

  # thread safe version using shallow copy of env
  def call!(env)
    @env = env.dup
    status, @headers, response = @app.call(@env)
    if processable_request?
      @headers.delete('Content-Length')
      response = Rack::Response.new(
        nice_typography(response.respond_to?(:body) ? response.body : response.to_s),
        status,
        @headers
      )
      response.finish
      response.to_a
    else
      [status, @headers, response]
    end
  end

  private

  def processable_request? #:nodoc:
    @headers["Content-Type"] &&
    @headers["Content-Type"].include?("text/html") &&
    (self.ignore_paths.empty? || !self.ignore_paths.any? { |p| @env["PATH_INFO"].start_with?(p) })
  end

  # converts a & surrounded by optional whitespace or a non-breaking space
  # to the HTML entity and surrounds it in a span with a styled class
  def amp(text)
    # $1 is an excluded HTML tag, $2 is the part before the caps and $3 is the amp match
    text.gsub(/<(code|pre).+?<\/\1>|(\s|&nbsp;)&(\s|&nbsp;)/) {|str|
    $1 ? str : $2 + '<span class="amp">&amp;</span>' + $3 }
  end

  # based on http://mucur.name/posts/widon-t-and-smartypants-helpers-for-rails
  # original concept from http://shauninman.com/archive/2006/08/22/widont_wordpress_plugin
  #
  # replaces space(s) before the last word (or tag before the last word)
  # before an optional closing element (a, em, span, strong) 
  # before a closing tag (p, h[1-6], li, dt, dd) or the end of the string
  def widont(text)
    text.gsub(%r/
      (\s+)                                           # some whitespace group 1
      (                                               # capture group 2
        (?:<(?:a|em|span|strong|i|b)[^>]*?>\s*)?      # an optional opening tag
        [^<>\s]+                                      # the matched word itself
        (?:<\/(?:a|em|span|strong|i|b)[^>]*?>\s*)?    # optional inline closing tags
        (?:\s*?<\/(?:p|h[1-6]|li|dt|dd)>)             # a closing element
      )/x, '&nbsp;\2')
  end

  # Uses RubyPants to transform various typographical elements to proper HTML entities
  # specifically, this includes:
  #
  # - Straight quotes ( " and ' ) into curly quote HTML entities
  # - Backticks-style quotes (``like this'') into curly quote HTML entities
  # - Dashes (-- and ---) into en- and em-dash entities
  # - Three consecutive dots (...) into an ellipsis entity
  #
  # Requires the RubyPants gem http://chneukirchen.org/blog/static/projects/rubypants.html
  # Based on SmartyPants http://daringfireball.net/projects/smartypants
  def rubypants(text)
    RubyPants.new(text).to_html
  end
  
  # main function to do all the functions from the method
  def nice_typography(text)
    widont(amp(rubypants(text)))
  end

end
