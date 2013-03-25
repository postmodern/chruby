%define name chruby
%define version 0.3.4
%define release 1

%define buildroot %{_topdir}/BUILDROOT

BuildRoot: %{buildroot}
Source0: https://github.com/postmodern/%{name}/archive/v%{version}.tar.gz
Summary: Changes the current Ruby.
Name: %{name}
Version: %{version}
Release: %{release}
License: MIT
AutoReqProv: no
BuildArch: noarch

%description
Changes the current Ruby.

%prep
%setup -q

%build

%install
make install PREFIX=%{buildroot}/usr

%files
%defattr(-,root,root)
/usr/bin/chruby-exec
/usr/share/%{name}/*
%doc
/usr/share/doc/%{name}-%{version}/*
