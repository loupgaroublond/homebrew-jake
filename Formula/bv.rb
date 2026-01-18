# Beads Viewer - graph-aware task management TUI
# Fresh from the spillway, still dripping with dependency graphs
class Bv < Formula
  desc "Graph-aware task management TUI for beads projects"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "6e21ee6ec7c14044b3a78a0ee4819bfa42ee2b60c52216bd71e64f3822164fb3"
  license "MIT"
  head "https://github.com/Dicklesworthstone/beads_viewer.git", branch: "main"

  depends_on "go" => :build

  def install
    # Enable SQLite FTS5 for full-text search support
    ENV["CGO_CFLAGS"] = "-DSQLITE_ENABLE_FTS5"

    ldflags = %W[
      -s -w
      -X github.com/Dicklesworthstone/beads_viewer/pkg/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/bv"
  end

  def caveats
    <<~EOS
      You've been SLOPPED with bv!

      To get started:
        1. Initialize beads in your project: bd init
        2. Launch the TUI: bv

      For AI agent integration, use --robot-* flags:
        bv --robot-triage     # Get prioritized recommendations
        bv --robot-next       # Get single next action

      Pro tip: Don't run bare `bv` from an AI agent - it launches
      an interactive TUI that'll block your session. Use --robot-* flags.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bv --version")
  end
end
