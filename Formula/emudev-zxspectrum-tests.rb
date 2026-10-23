class EmudevZxspectrumTests < Formula
  desc "Collection of ZX Spectrum tests"
  homepage "https://zxe.io/depot"
  url "https://zxe.io/depot/download/ZX%20Spectrum%20-%20Tests%20%282026-10-09%29.zip"
  version "20261009"
  sha256 "9cccc8d47b21bdb3ed2c2428b798ac513331137923230d53c942b8bcf5a1b976"
  license :cannot_represent

  def install
    (share/"emudev/ZX Spectrum/Software").install Dir.children(buildpath)
  end

  test do
    assert_predicate share/"emudev/ZX Spectrum/Software", :directory?
  end
end
