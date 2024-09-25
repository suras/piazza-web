class ApplicationMailbox < ActionMailbox::Base
  # routing /something/i => :somewhere
  routing /^conversation\+(\S+)@/i => :conversation
end
