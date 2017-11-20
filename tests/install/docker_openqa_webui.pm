use strict;
use base "openQAcoretest";
use testapi;
use utils;


sub run {
    send_key "ctrl-alt-f2";
    assert_screen "inst-console";
    type_string "root\n";
    assert_screen "password-prompt";
    type_string $testapi::password . "\n";
    wait_still_screen(2);
    diag('Ensure packagekit is not interfering with zypper calls');
    script_run('systemctl stop packagekit.service; systemctl mask packagekit.service');

    assert_command_run('docker pull slindomansilla/openqa-webui');
    assert_command_run('docker run -d --name openqa_webui -p 80:80 -p 873:873 slindomansilla/openqa-webui');
    assert_command_output('docker ps | grep openqa_webui')

    install_from_repos;
    save_screenshot;
    type_string "clear\n";
}

1;
