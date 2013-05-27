%define name chruby
%define version 0.3.4
%define release 1

%define buildroot %{_topdir}/BUILDROOT

BuildRoot: %{buildroot}
Source0: https://github.com/postmodern/%{name}/archive/v%{version}.tar.gz
Summary: Changes the current Ruby
Name: %{name}
Version: %{version}
Release: %{release}
License: MIT
URL: https://github.com/postmodern/chruby#readme
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
%{_bindir}/chruby-exec
%{_datadir}/%{name}/*
%doc
%{_defaultdocdir}/%{name}-%{version}/*

%changelog
* Sun Mar 24 2013 Postmodern <postmodern.mod3@gmail.com> - 0.3.4-1
- Rebuilt for version 0.3.4.
