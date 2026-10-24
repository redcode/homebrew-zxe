class LibarchiveAppleHeaders < Formula
  desc "Headers for the version of libarchive shipped with macOS"
  homepage "https://github.com/apple-oss-distributions/libarchive"
  url "https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-167.120.3.tar.gz"
  version "3.7.4" # See https://github.com/apple-oss-distributions/libarchive/blob/libarchive-167.120.3/libarchive.plist
  sha256 "f7dbab8eca7685d75eb22e244e989bf337155701f577dbe3091a2eb7314b7973"
  license "BSD-2-Clause"

  def install
    include.install "libarchive/libarchive/archive.h"
    include.install "libarchive/libarchive/archive_entry.h"
  end

  livecheck do
    skip "Version is pinned to the macOS system libarchive and must be bumped manually"
  end

  test do
    system(true)
  end
end
