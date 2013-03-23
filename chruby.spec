%define name chruby
%define version 0.3.4
%define release 1

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

%files
%defattr(-,root,root)
/usr/bin/chruby-exec
/usr/share/%{name}/*
/usr/share/doc/%{name}-%{version}/*
