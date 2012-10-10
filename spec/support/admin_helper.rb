module AdminHelper
  def test_admin_login
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('test_admin', 'potato_topiary')
  end
end