class Machbatch < Formula
  COMPATIBILITY_COMMANDS = %w[
    sinfo
    squeue
    sbatch
    srun
    salloc
    scancel
    sacct
    sstat
    sprio
    scontrol
    sacctmgr
  ].freeze

  desc "Native macOS workload manager with a Slurm-compatible CLI"
  homepage "https://github.com/kodlabs-in/machbatch"
  url "https://github.com/kodlabs-in/machbatch/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "361121e5b355398e8e066986a984b30d624cdbf01f326a01da567c8bc455248b"
  license "MIT"
  head "https://github.com/kodlabs-in/machbatch.git", branch: "main"

  depends_on xcode: ["26.0", :build]
  depends_on macos: :ventura

  def install
    system "swift", "build", *std_swift_args

    bin.install ".build/release/machbatch", ".build/release/machbatchd"
    COMPATIBILITY_COMMANDS.each { |command| bin.install_symlink "machbatch" => command }
  end

  test do
    ENV["MACHBATCH_DATA_DIR"] = testpath/"data"

    assert_equal "MachBatch #{version} — Slurm 26.05.4 CLI-compatible\n",
                 shell_output("#{bin}/machbatch --version")
    assert_match "database: ok", shell_output("#{bin}/machbatch doctor")
    assert_match "PARTITION AVAIL", shell_output("#{bin}/sinfo")

    COMPATIBILITY_COMMANDS.each { |command| assert_path_exists bin/command }

    assert_equal "Submitted batch job 1\n",
                 shell_output("#{bin}/sbatch --wrap /usr/bin/true")
    system bin/"machbatchd", "--once"
    assert_match "COMPLETED", shell_output("#{bin}/sacct --jobs 1")
  end
end
