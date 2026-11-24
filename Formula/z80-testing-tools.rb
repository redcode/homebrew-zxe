class Z80TestingTools < Formula
  desc "Zilog Z80 CPU emulator (testing tools)"
  homepage "https://github.com/redcode/Z80"
  url "https://zxe.io/software/Z80/download/Z80-0.2-pre-2025-07-02.tar.xz"
  version "0.2-pre-2025-07-02"
  sha256 "0da953932d472f73b9f61ae5f33c2c178044eadc141448f7dd6aa9da47242a83"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "cjson"
  depends_on "libzip"
  depends_on "z80"
  depends_on "z80insnclock"
  depends_on "zeta"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=YES
      -DCMAKE_VERBOSE_MAKEFILE=YES
      -DZ80_FETCH_TEST_FILES=NO
      -DZ80_NOSTDLIB_FLAGS=Auto
      -DZ80_WITH_CMAKE_SUPPORT=YES
      -DZ80_WITH_HTML_DOCUMENTATION=NO
      -DZ80_WITH_PDF_DOCUMENTATION=NO
      -DZ80_WITH_PKGCONFIG_SUPPORT=YES
      -DZ80_WITH_STANDARD_DOCUMENTS=NO
      -DZ80_WITH_STEP_TESTING_TOOL=YES
      -DZ80_WITH_TESTING_TOOL=YES
      -DZ80_WITH_EXECUTE=YES
      -DZ80_WITH_FULL_IM0=YES
      -DZ80_WITH_IM0_RETX_NOTIFICATIONS=YES
      -DZ80_WITH_Q=YES
      -DZ80_WITH_SPECIAL_RESET=NO
      -DZ80_WITH_UNOFFICIAL_RETI=NO
      -DZ80_WITH_ZILOG_NMOS_LD_A_IR_BUG=YES
    ]
    # `libZ80` is built here but installed by the `z80` formula. Its install
    # name is forced so that the tools are linked against it by absolute path
    # instead of an unresolved `@rpath` reference.
    args << "-DCMAKE_INSTALL_NAME_DIR=#{formula_opt_lib("z80")}"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--component", "Z80_Testing", "--strip"
  end

  test do
    system "#{bin}/step-test-Z80", "--version"
    system "#{bin}/test-Z80", "--version"
  end
end
