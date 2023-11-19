class ZxspectrumFirmware < Formula
  desc "Collection of ZX Spectrum firmware"
  homepage "https://zxe.io/depot"
  url "https://zxe.io/depot/download/ZX%20Spectrum%20-%20Firmware%20%282023-11-19%29.7z"
  sha256 "a291f5badad266c680f70c4f3087f0ce641bbb1ef97295ac42a01069029569c6"
  license :cannot_represent

  depends_on "p7zip" => :build

  def install
    (lib/"emulation/firmware").install Dir["*.rom"]
  end

  test do
    system(true)
  end
end
