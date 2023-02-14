class Z80 < Formula
  desc "Zilog Z80 CPU emulator"
  homepage "https://github.com/redcode/Z80"
  url "https://zxe.io/software/Z80/download/Z80-0.2-pre-2023-02-14.tar.xz"
  version "0.2-pre-2023-02-14"
  sha256 "84b72f4f3ff42fbb485a4291798139423fa50337507a8207c013dd9120a8dd6d"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "zeta"

  def install
    system "cmake",
      "-S", ".", "-B", "build",
      "-DBUILD_SHARED_LIBS=YES",
      "-DCMAKE_VERBOSE_MAKEFILE=YES",
      "-DZ80_FETCH_TEST_FILES=NO",
      "-DZ80_NOSTDLIB_FLAGS=Auto",
      "-DZ80_WITH_CMAKE_SUPPORT=YES",
      "-DZ80_WITH_HTML_DOCUMENTATION=NO",
      "-DZ80_WITH_PDF_DOCUMENTATION=NO",
      "-DZ80_WITH_PKGCONFIG_SUPPORT=YES",
      "-DZ80_WITH_STANDARD_DOCUMENTS=NO",
      "-DZ80_WITH_TESTS=NO",
      "-DZ80_WITH_EXECUTE=YES",
      "-DZ80_WITH_FULL_IM0=YES",
      "-DZ80_WITH_IM0_RETX_NOTIFICATIONS=NO",
      "-DZ80_WITH_Q=YES",
      "-DZ80_WITH_SPECIAL_RESET=NO",
      "-DZ80_WITH_UNOFFICIAL_RETI=NO",
      "-DZ80_WITH_ZILOG_NMOS_LD_A_IR_BUG=YES",
      *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <Z80.h>
      #include <Z/constants/pointer.h>
      #include <Z/macros/language.h>
      #include <stdio.h>
      #include <string.h>

      static zuint8 memory[65536];

      static zuint8 cpu_read(void *context, zuint16 address)
        {
        Z_UNUSED(context)
        return memory[address];
        }

      static void cpu_write(void *context, zuint16 address, zuint8 value)
        {
        Z_UNUSED(context)
        memory[address] = value;
        }

      static zuint8 cpu_in(void *context, zuint16 port)
        {
        Z_UNUSED(context) Z_UNUSED(port)
        return 255;
        }

      static void cpu_out(void *context, zuint16 port, zuint8 value)
        {
        Z_UNUSED(context) Z_UNUSED(port) Z_UNUSED(value)
        }

      int main(int argc, char **argv)
        {
        Z80 cpu;
        Z_UNUSED(argc) Z_UNUSED(argv)
        cpu.context      = Z_NULL;
        cpu.fetch_opcode =
        cpu.fetch        =
        cpu.read         = cpu_read;
        cpu.write        = cpu_write;
        cpu.in           = cpu_in;
        cpu.out          = cpu_out;
        cpu.halt         = Z_NULL;
        cpu.nop          =
        cpu.nmia         =
        cpu.inta         =
        cpu.int_fetch    = Z_NULL;
        cpu.ld_i_a       =
        cpu.ld_r_a       =
        cpu.reti         =
        cpu.retn         = Z_NULL;
        cpu.hook         = Z_NULL;
        cpu.illegal      = Z_NULL;
        memset(memory, 0, 65536);
        z80_power(&cpu, TRUE);
        z80_run(&cpu, 65536 * 4);
        puts(cpu.cycles == 65536 * 4 && !Z80_PC(cpu) ? "passed" : "failed");
        return 0;
        }
    EOS

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.3)
      project(test LANGUAGES C)
      find_package(Z80 REQUIRED)
      add_executable(test "${CMAKE_CURRENT_SOURCE_DIR}/test.c")
      target_link_libraries(test PRIVATE Z80)
    EOS

    system "cmake", "-S", testpath, "-B", (testpath/"build"), *std_cmake_args
    system "cmake", "--build", (testpath/"build")
    assert_equal "passed", shell_output(testpath/"build"/"test-client").strip
  end
end
