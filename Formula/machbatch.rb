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
  url "https://github.com/kodlabs-in/machbatch/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "652e58beae151881e93077ca49965e0a55a8a89926600cdcf55b439443e80f97"
  license "MIT"
  head "https://github.com/kodlabs-in/machbatch.git", branch: "main"

  bottle do
    root_url "https://github.com/kodlabs-in/homebrew-tap/releases/download/machbatch-0.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "b8d49dca3ebc3458c6bf89643c00efea4dc68bc759619509c60e6bbba3f74ce7"
  end

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
