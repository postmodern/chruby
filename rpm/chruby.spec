Name:           chruby
Version:        0.3.9
Release:        1%{?dist}
Summary:        Change current ruby
License:        MIT
URL:            https://github.com/postmodern/%{name}
Source0:        https://github.com/postmodern/%{name}/archive/v%{version}.tar.gz
Source1:        chruby_profile.sh
BuildArch:      noarch

%description
Changes the current Ruby.

%prep
%setup -q

%build

%install
make install PREFIX=%{buildroot}%{_prefix}
install -D -p -m 644 %{SOURCE1} %{buildroot}%{_sysconfdir}/profile.d/chruby.sh

%files
%{_bindir}/chruby-exec
%{_datadir}/%{name}/
%config %{_sysconfdir}/profile.d/chruby.sh
%doc %{_defaultdocdir}/%{name}-%{version}/

%changelog
* Sun Nov 23 2014 Postmodern <postmodern.mod3@gmail.com> - 0.3.9-1
- Rebuilt for version 0.3.9.

* Wed Dec 04 2013 Postmodern <postmodern.mod3@gmail.com> - 0.3.8-1
- Rebuilt for version 0.3.8.

* Sun Aug 18 2013 Postmodern <postmodern.mod3@gmail.com> - 0.3.7-1
- Rebuilt for version 0.3.7.

* Mon Jun 24 2013 Postmodern <postmodern.mod3@gmail.com> - 0.3.6-1
- Rebuilt for version 0.3.6.

* Tue May 28 2013 Postmodern <postmodern.mod3@gmail.com> - 0.3.5-1
- Rebuilt for version 0.3.5.

* Sun Mar 24 2013 Postmodern <postmodern.mod3@gmail.com> - 0.3.4-1
- Rebuilt for version 0.3.4.
