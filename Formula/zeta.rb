class Zeta < Formula
  desc "Header-only general purpose library"
  homepage "https://github.com/redcode/Zeta"
  url "https://zeta.st/download/Zeta-0.1-pre-2023-08-11.tar.xz"
  version "0.1-pre-2023-06-15"
  sha256 "2181b890fb3da2b7311c9c684165520b2623f91107604a1790afddd021588618"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build

  def install
    system "cmake",
      "-S", ".", "-B", "build",
      "-DZeta_WITH_CMAKE_SUPPORT=YES",
      "-DZeta_WITH_PKGCONFIG_SUPPORT=YES",
      *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <Z/version.h>
      #include <Z/macros/language.h>
      #include <stdio.h>
      int main(int argc, char **argv)
        {
        Z_UNUSED(argc) Z_UNUSED(argv)
        puts(Z_LIBRARY_VERSION_STRING);
        return 0;
        }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-o", "test"
    assert_equal "0.1", shell_output("./test").strip
  end
end
