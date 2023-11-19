class Zx81 < Formula
  desc "ZX81 firmware collection"
  homepage "https://zxe.io/depot"
  url "https://zxe.io/depot/download/ZX81%20-%20Firmware%20%282023-11-19%29.7z"
  sha256 "8dda82c9b135c902e7fbb531200ee8ec8aaa8b6d2ff673728f345cf55618c748"
  license :cannot_represent

  depends_on "p7zip" => :build

  def install
    (lib/"emulation/firmware").install Dir["*.rom"]
  end

  test do
    system(true)
  end
end
