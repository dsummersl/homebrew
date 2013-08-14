require 'formula'

class Watchman < Formula
  homepage 'https://github.com/facebook/watchman'
  url 'https://github.com/facebook/watchman/archive/v2.8.2.tar.gz'
  sha1 'd46f5fa29de4fb30d7dcc0ec7998099567b09a5f'

  head 'https://github.com/facebook/watchman.git'

  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on 'pkg-config' => :build
  depends_on 'pcre' => :recommended

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    ]

    system "./autogen.sh"

    if build.with? 'pcre'
      system "./configure", "--with-pcre", *args
    else
      system "./configure", *args
    end

    system "make"
    system "make install"
  end

  def caveats
    <<-EOS.undent
    To increase file limits add 'kern.maxfiles=10485760' and 'kern.maxfilesperproc=10485760'
    to /etc/sysctl.conf (use 'sysctl -w' to do so immediately).
        
    See https://github.com/facebook/watchman#max-os-file-descriptor-limits
    EOS
  end
end
