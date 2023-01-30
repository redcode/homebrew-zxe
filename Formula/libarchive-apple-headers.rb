class LibarchiveAppleHeaders < Formula
  desc "Headers for the version of libarchive shipped with macOS"
  homepage "https://github.com/apple-oss-distributions/libarchive"
  url "https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-113.tar.gz"
  version "3.5.3" # See https://github.com/apple-oss-distributions/libarchive/blob/431afa166497a0d67ef0ede2ed04b121a3b5a9d3/libarchive.plist
  sha256 "1a7d8d15b2e5ecba62cc5779a9f0e811ffa9221c7805b136ceb9c2ee7d8dc0d5"
  license "BSD-2-Clause"

  def install
    include.install "libarchive/libarchive/archive.h"
    include.install "libarchive/libarchive/archive_entry.h"
  end

  test do
    system(true)
  end
end
