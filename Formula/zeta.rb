class Zeta < Formula
  desc "Header-only general purpose library"
  homepage "https://github.com/redcode/Zeta"
  url "https://zeta.st/download/Zeta-0.1-pre-2023-10-20.tar.xz"
  version "0.1-pre-2023-10-20"
  sha256 "4d9819c925da68580b7a52f5f0769a6e0cb4275eda6401e5e0048ee2183d8463"
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
