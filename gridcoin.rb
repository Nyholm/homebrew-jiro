class Gridcoin < Formula
  desc "OS X client (GUI and CLI)"
  homepage "https://gridcoin.us/"
  url "https://github.com/gridcoin/Gridcoin-Research/archive/3.5.8.8b.tar.gz"
  version "3.5.8.8b"
  sha256 "601190f4438f8be762bfeea1dfd50d5fad4cd916c2c5bc92e24ae31b417bdcd6"
  head "https://github.com/gridcoin/Gridcoin-Research.git", :branch => "master"

  devel do
    url "https://github.com/gridcoin/Gridcoin-Research.git", :using => :git, :branch => "development"
    version "3.5.8.8b-dev"
  end

  option "without-upnp", "Do not compile with UPNP support"
  option "with-cli", "Also compile the command line client"
  option "without-gui", "Do not compile the graphical client"

  depends_on "boost"
  depends_on "berkeley-db@4"
  depends_on "openssl"
  depends_on "miniupnpc"
  depends_on "libzip"
  depends_on "pkg-config" => :build
  depends_on "qrencode"
  depends_on "Git-Jiro/jiro/qt"

  def install
    if build.with? "upnp"
      upnp_build_var = "1"
    else
      upnp_build_var = "-"
    end

    if build.with? "cli"
      chmod 0755, "src/leveldb/build_detect_platform"
      mkdir_p "src/obj/zerocoin"
      system "make", "-C", "src", "-f", "makefile.osx", "USE_UPNP=#{upnp_build_var}"
      bin.install "src/gridcoinresearchd"
    end

    if build.with? "gui"
      system "qmake", "USE_UPNP=#{upnp_build_var}"
      system "make"
      prefix.install "gridcoinresearch.app"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test Gridcoin`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
