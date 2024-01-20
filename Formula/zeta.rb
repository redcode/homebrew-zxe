class Zeta < Formula
  desc "Header-only general purpose library"
  homepage "https://github.com/redcode/Zeta"
  url "https://zeta.st/download/Zeta-0.1-pre-2024-01-20.tar.xz"
  version "0.1-pre-2024-01-20"
  sha256 "987e0a3cdac7e04ac6de2fc671b42495ae92f066cd95b9aa7e2a36efec133f11"
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
