class Z80insnclock < Formula
  desc "Z80 instruction clock"
  homepage "https://github.com/agaxia/Z80InsnClock"
  url "https://zxe.io/software/Z80InsnClock/download/Z80InsnClock-0.1-pre-2024-12-25.tar.xz"
  version "0.1-pre-2024-12-25"
  sha256 "4f403552a73908793f6c7112b1f57ce3cba3b70bd6b569807f21b8ae6512ac49"
  license "0BSD"

  depends_on "cmake" => :build
  depends_on "zeta"

  def install
    system "cmake",
      "-S", ".", "-B", "build",
      "-DBUILD_SHARED_LIBS=YES",
      "-DCMAKE_VERBOSE_MAKEFILE=YES",
      "-DZ80InsnClock_NOSTDLIB_FLAGS=Auto",
      "-DZ80InsnClock_WITH_CMAKE_SUPPORT=YES",
      "-DZ80InsnClock_WITH_HTML_DOCUMENTATION=NO",
      "-DZ80InsnClock_WITH_PDF_DOCUMENTATION=NO",
      "-DZ80InsnClock_WITH_PKGCONFIG_SUPPORT=YES",
      "-DZ80InsnClock_WITH_STANDARD_DOCUMENTS=NO",
      "-DZ80InsnClock=All",
      *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <Z80InsnClock.h>
      #include <Z/constants/pointer.h>
      #include <stdio.h>
      #include <string.h>

      static zuint8 cpu_read(void *context, zuint16 address)
        {
        Z_UNUSED(context)
        return address == 0x5678 ? 0x12 : 0;
        }

      int main(int argc, char **argv)
        {
        Z80InsnClock clock;
        ZInt16 af, bc, hl;
        zuint8 extra_cycles[3];
        Z_UNUSED(argc) Z_UNUSED(argv)

        /* Check T-states of `cpir` when the repeat condition is met. */

        af.uint16_value = 0x1234;
        bc.uint16_value = 0;
        hl.uint16_value = 0x5678;
        z80_insn_clock_initialize(&clock, &af, &bc, &hl, Z_NULL, cpu_read);
        z80_insn_clock_start(&clock, 0);
        extra_cycles[0] = z80_insn_clock_extra_m1(&clock, 0xED);
        z80_insn_clock_extra_add_m1(&clock, extra_cycles[0]);
        extra_cycles[1] = z80_insn_clock_extra_m1(&clock, 0xB1);
        z80_insn_clock_extra_add_m1(&clock, extra_cycles[1]);
        extra_cycles[2] = z80_insn_clock_extra_m(&clock);
        z80_insn_clock_extra_add_m(&clock, extra_cycles[2]);

        puts(
          extra_cycles[0] == 0 &&
          extra_cycles[1] == 0 &&
          extra_cycles[2] == 5 &&
          clock.cycles    == 16
            ? "passed" : "failed");

        return 0;
        }
    EOS

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.3)
      project(test LANGUAGES C)
      find_package(Z80InsnClock REQUIRED)
      add_executable(test "${CMAKE_CURRENT_SOURCE_DIR}/test.c")
      target_link_libraries(test PRIVATE Z80InsnClock)
    EOS

    system "cmake", "-S", testpath, "-B", (testpath/"build"), *std_cmake_args
    system "cmake", "--build", (testpath/"build")
    assert_equal "passed", shell_output(testpath/"build"/"test-client").strip
  end
end
