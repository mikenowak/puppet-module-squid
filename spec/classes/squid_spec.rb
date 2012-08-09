require 'spec_helper'

describe 'squid', :type => 'class' do

  let(:title) { 'squid' }
  let(:node) { 'puppetdev.casanowak.com' }

  debianish              = [ 'Debian', 'Ubuntu' ]
  debianish_package      = 'squid'
  debianish_config_path  = '/etc/squid/squid.conf'
  debianish_config_mode  = '0600'
  debianish_config_owner = 'root'
  debianish_config_group = 'root'

  debianish_service      = 'squid'

  redhatish              = [ 'RedHat', 'CentOS', 'Fedora' ]
  redhatish_package      = 'squid'
  redhatish_config_path  = '/etc/squid/squid.conf'
  redhatish_config_mode  = '0600'
  redhatish_config_owner = 'root'
  redhatish_config_group = 'root'

  redhatish_service      = 'squid'

  unknown                = [ 'Foobar' ]


  describe 'Test installation' do

    debianish.each do |os|
      describe "for operating system #{os}" do
        let(:params) { {} }
        let(:facts) { {:operatingsystem => os } }

        ### Components

        # package
        it { should contain_package("#{debianish_package}").with_ensure('present') }

        # config
        it { should contain_file("#{debianish_config_path}").with_ensure('present') }
        it { should contain_file("#{debianish_config_path}").with_mode("#{debianish_config_mode}") }
        it { should contain_file("#{debianish_config_path}").with_owner("#{debianish_config_owner}") }
        it { should contain_file("#{debianish_config_path}").with_group("#{debianish_config_group}") }
        it { should contain_file("#{debianish_config_path}").with_notify("Service[#{debianish_service}]") }

        # service
        it { should contain_service("#{debianish_service}").with_ensure('running') }
        it { should contain_service("#{debianish_service}").with_enable('true') }
        it { should contain_service("#{debianish_service}").with_hasstatus('true') }
        it { should contain_service("#{debianish_service}").with_hasrestart('true') }
        it { should contain_service("#{debianish_service}").with_pattern("#{debianish_service}") }


        ### Parameters
        
        # version
        it 'should allow package version to be overridden with version => "1.2.3"' do
          params[:version] = '1.2.3'
          subject.should contain_package("#{debianish_package}").with_ensure('1.2.3')
        end
        it 'should allow package version to be overridden with version => "latest"' do
          params[:version] = 'latest'
          subject.should contain_package("#{debianish_package}").with_ensure('latest')
        end

        # status
        it 'should allow service status to be overridden with status => "disabled"' do
          params[:status] = 'disabled'
          subject.should contain_service("#{debianish_service}").with_ensure('stopped')
          subject.should contain_service("#{debianish_service}").with_enable('false')
        end
        it 'should allow service status to be overridden with status => "running"' do
          params[:status] = 'running'
          subject.should contain_service("#{debianish_service}").with_ensure('running')
          subject.should contain_service("#{debianish_service}").with_enable('false')
        end
        it 'should allow service status to be overridden with status => "unmanaged"' do
          params[:status] = 'unmanaged'
          subject.should contain_service("#{debianish_service}").without_ensure
          subject.should contain_service("#{debianish_service}").with_enable('false')
        end

        # template
        it 'should allow template to be overridden' do
          params[:template] = 'squid/spec.erb'
          content = catalogue.resource('file', "#{debianish_config_path}").send(:parameters)[:content]
          content.should match "value_a"
        end

        # options
        it 'should generate a template that uses a custom option' do
          params[:template] = 'squid/spec.erb'
          params[:options]  = { 'opt_a' => 'value_z' }
          content = catalogue.resource('file', "#{debianish_config_path}").send(:parameters)[:content]
          content.should match "value_z"
        end

        # acl_src
        it 'should generate valid config from a template that uses default acl_src' do
          params[:template] = 'squid/spec.erb'
          content = catalogue.resource('file', "#{debianish_config_path}").send(:parameters)[:content]
          content.should match "acl any src 0.0.0.0/0"
        end
        it 'should generate valid config from a template that uses custom acl_src' do
          params[:acl_src]  = { 'build-net' => '172.16.10.0/24' }
          params[:template] = 'squid/spec.erb'
          content = catalogue.resource('file', "#{debianish_config_path}").send(:parameters)[:content]
          content.should match "acl build-net src 172.16.10.0/24"
        end

      end
    end

    redhatish.each do |os|
      describe "for operating system #{os}" do
        let(:params) { {} }
        let(:facts) { {:operatingsystem => os } }

        ### Components

        # package
        it { should contain_package("#{redhatish_package}").with_ensure('present') }

        # config
        it { should contain_file("#{redhatish_config_path}").with_ensure('present') }
        it { should contain_file("#{redhatish_config_path}").with_mode("#{redhatish_config_mode}") }
        it { should contain_file("#{redhatish_config_path}").with_owner("#{redhatish_config_owner}") }
        it { should contain_file("#{redhatish_config_path}").with_group("#{redhatish_config_group}") }
        it { should contain_file("#{redhatish_config_path}").with_notify("Service[#{redhatish_service}]") }

        # service
        it { should contain_service("#{redhatish_service}").with_ensure('running') }
        it { should contain_service("#{redhatish_service}").with_enable('true') }
        it { should contain_service("#{redhatish_service}").with_hasstatus('true') }
        it { should contain_service("#{redhatish_service}").with_hasrestart('true') }
        it { should contain_service("#{redhatish_service}").with_pattern("#{redhatish_service}") }


        ### Parameters

        # version
        it 'should allow package version to be overridden with version => "1.2.3"' do
          params[:version] = '1.2.3'
          subject.should contain_package("#{redhatish_package}").with_ensure('1.2.3')
        end
        it 'should allow package version to be overridden with version => "latest"' do
          params[:version] = 'latest'
          subject.should contain_package("#{redhatish_package}").with_ensure('latest')
        end

        # status
        it 'should allow service status to be overridden with status => "disabled"' do
          params[:status] = 'disabled'
          subject.should contain_service("#{redhatish_service}").with_ensure('stopped')
          subject.should contain_service("#{redhatish_service}").with_enable('false')
        end
        it 'should allow service status to be overridden with status => "running"' do
          params[:status] = 'running'
          subject.should contain_service("#{redhatish_service}").with_ensure('running')
          subject.should contain_service("#{redhatish_service}").with_enable('false')
        end
        it 'should allow service status to be overridden with status => "unmanaged"' do
          params[:status] = 'unmanaged'
          subject.should contain_service("#{redhatish_service}").without_ensure
          subject.should contain_service("#{redhatish_service}").with_enable('false')
        end

        # template
        it 'should allow template to be overridden' do
          params[:template] = 'squid/spec.erb'
          content = catalogue.resource('file', "#{redhatish_config_path}").send(:parameters)[:content]
          content.should match "value_a"
        end

        # options
        it 'should generate a template that uses a custom option' do
          params[:template] = 'squid/spec.erb'
          params[:options]  = { 'opt_a' => 'value_z' }
          content = catalogue.resource('file', "#{redhatish_config_path}").send(:parameters)[:content]
          content.should match "value_z"
        end

        # acl_src
        it 'should generate valid config from a template that uses default acl_src' do
          params[:template] = 'squid/spec.erb'
          content = catalogue.resource('file', "#{redhatish_config_path}").send(:parameters)[:content]
          content.should match "acl any src 0.0.0.0/0"
        end
        it 'should generate valid config from a template that uses custom acl_src' do
          params[:acl_src]  = { 'build-net' => '172.16.10.0/24' }
          params[:template] = 'squid/spec.erb'
          content = catalogue.resource('file', "#{redhatish_config_path}").send(:parameters)[:content]
          content.should match "acl build-net src 172.16.10.0/24"
        end

      end
    end

    unknown.each do |os|
      describe "for an unknown operating system" do
        let(:params) { {} }
        let(:facts) { {:operatingsystem => os } }

        it { expect { should contain_package('squid').with_ensure('present') }.to raise_error(Puppet::Error, /"#{title}" provides no package default value for "#{os}"/) }
      end
    end

  end

describe 'Test uninstallation' do

    debianish.each do |os|
      describe "for operating system #{os}" do
        let(:params) { {:ensure => 'absent' } }
        let(:facts) { {:operatingsystem => os } }

        ### Components
 
        # package
        it { should contain_package("#{debianish_package}").with_ensure('purged') }
 
        # config
        it { should contain_file("#{debianish_config_path}").with_ensure('absent') }

        # service
        it { should contain_service("#{debianish_service}").with_ensure('stopped') }
        it { should contain_service("#{debianish_service}").with_enable('false') }
      end
    end

    redhatish.each do |os|

      describe "for operating system #{os}" do
        let(:params) { {:ensure => 'absent' } }
        let(:facts) { {:operatingsystem => os } }

        ### Components

        # package
        it { should contain_package("#{redhatish_package}").with_ensure('purged') }

        # config
        it { should contain_file("#{redhatish_config_path}").with_ensure('absent') }

        # service
        it { should contain_service("#{redhatish_service}").with_ensure('stopped') }
        it { should contain_service("#{redhatish_service}").with_enable('false') }
      end
    end

    unknown.each do |os|
      describe "for an unknown operating system" do
        let(:params) {{}}
        let(:facts) { {:operatingsystem => os } }

        it { expect { should contain_package('squid').with_ensure('present') }.to raise_error(Puppet::Error, /"#{title}" provides no package default value for "#{os}"/) }
      end
    end

  end

  describe 'Test for invalid parameters' do

    (debianish + redhatish).each do |os|
      describe "for operating system #{os}" do
        let(:facts) { {:operatingsystem => os } }
        let(:params) { { } }

        it 'invalid ensure value should generate error' do
          params[:ensure] = 'foo'
          expect { subject.should contain_package('squid').with_ensure('present') }.to raise_error(Puppet::Error, /"#{params[:ensure]}" is not a valid ensure parameter value/)
        end

        it 'invalid status value should generate error' do
          params[:status] = 'bar'
          expect { subject.should contain_service('squid').with_ensure('running') }.to raise_error(Puppet::Error, /"#{params[:status]}" is not a valid status parameter value/)
        end
        
      end
    end

  end

end
