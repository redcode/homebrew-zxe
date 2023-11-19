class Zx80Firmware < Formula
  desc "Collection of ZX81 firmware"
  homepage "https://zxe.io/depot"
  url "https://zxe.io/depot/download/ZX80%20-%20Firmware%20%282023-11-19%29.7z"
  sha256 "a1e8fab0493a4f3b595b1a2925f5a093156ea0c0921b66210c75b96a36e07ce9"
  license :cannot_represent

  depends_on "p7zip" => :build

  def install
    (lib/"emulation/firmware").install Dir["*.rom"]
  end

  test do
    system(true)
  end
end
