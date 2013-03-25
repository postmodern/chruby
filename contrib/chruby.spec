%define name chruby
%define version 0.3.4
%define release 1
#git archive --format=tar --prefix=chruby-0.3.4/ v0.3.4 | gzip > chruby-0.3.4.tar.gz  

%define buildroot %{_topdir}/BUILDROOT

BuildRoot: %{buildroot}
Source0: %{name}-%{version}.tar.gz
Summary: It's chruby!
Name: %{name}
Version: %{version}
Release: %{release}
License: Other
AutoReqProv: no
BuildArch: noarch

%description

%prep
%setup -q

%build

%install
make install PREFIX=%{buildroot}/usr
install -D -m 755 scripts/setup.sh %{buildroot}/usr/share/%{name}/setup.sh
install -D -m 755 scripts/bug_report.sh %{buildroot}/usr/share/%{name}/bug_report.sh

%files
%defattr(-,root,root)
/usr/bin/chruby-exec
/usr/share/%{name}/*
/usr/share/doc/%{name}-%{version}/*
