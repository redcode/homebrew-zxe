class ZxspectrumFirmware < Formula
  desc "ZX Spectrum ROM images"
  homepage "https://github.com/redcode/ZXSpectrum/wiki"
  url "https://zxe.io/depot/ZX%20Spectrum%20-%20Firmware%20%282023-11-18%29.7z"
  sha256 "14e0d5ffedf88e42b7b8caf173fdcd8f93e9463885df955ec257c0db94399df6"
  license :cannot_represent

  depends_on "p7zip" => :build

  def install
    (lib/"emulation/firmware").install Dir["*.rom"]
  end

  test do
    system(true)
  end
end
