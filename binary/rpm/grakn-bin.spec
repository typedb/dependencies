Name: grakn-bin
Version: devel
Release: 1
Summary: Grakn Core (bin)
URL: https://grakn.ai
License: Apache License, v2.0
AutoReqProv: no

Source0: {_grakn-bin-rpm-tar.tar.gz}

Requires: java-1.8.0-openjdk-headless
Requires: which

%description
Grakn Core (server) - description

%prep

%build

%install
mkdir -p %{buildroot}
tar -xvf {_grakn-bin-rpm-tar.tar.gz} -C %{buildroot}
rm -fv {_grakn-bin-rpm-tar.tar.gz}

%files

/opt/grakn/
/usr/local/bin/grakn
%attr(777, -, -) /var/log/grakn
