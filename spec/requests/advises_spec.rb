require 'spec_helper'

describe "Advises" do
  describe "GET /advises" do
    it "redirect before login" do
      get advises_path
      response.should redirect_to(new_user_session_path)
    end
  end
end
