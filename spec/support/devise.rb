module DeviseRoutingHelpers
  # workaround for this issue https://github.com/plataformatec/devise/issues/1670
  def mock_warden_for_route_tests!
    warden = double
    allow_any_instance_of(ActionDispatch::Request).to receive(:env)
      .and_wrap_original { |orig, *args|
                                                        env = orig.call(*args)
                                                        env["warden"] = warden
                                                        env
                                                      }
    allow(warden).to receive(:authenticate!).with({scope: :user}).and_return(true)
    allow(warden).to receive(:authenticate?).with({scope: :user}).and_return(true)
  end
end
