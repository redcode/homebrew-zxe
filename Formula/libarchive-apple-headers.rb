class LibarchiveAppleHeaders < Formula
  desc "Headers for the version of libarchive shipped with macOS"
  homepage "https://github.com/apple-oss-distributions/libarchive"
  url "https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-113.tar.gz"
  version "3.5.3" # See https://github.com/apple-oss-distributions/libarchive/blob/431afa166497a0d67ef0ede2ed04b121a3b5a9d3/libarchive.plist
  sha256 "b422c37cc5f9ec876d927768745423ac3aae2d2a85686bc627b97e22d686930f"
  license "BSD-2-Clause"

  def install
    include.install "libarchive/libarchive/archive.h"
    include.install "libarchive/libarchive/archive_entry.h"
  end

  test do
    system(true)
  end
end
