require 'rails_helper'

RSpec.describe User, type: :model do
  it "名前、emailを登録すると、名前、emailが取得できる" do
    user = User.new(name: "Odat", email: "oda620@icloud.com")
    expect(user.name_email).to eq "Odat, oda620@icloud.com"
  end
end