# ANTA Notes - swamaki

ANTA is Arista Network Test Automation - a python testing framework that automates tests for Arista Devices

### Documentation

[ANTA Website](https://anta.arista.com)

[ANTA Tests Documentation](https://anta.arista.com/stable/api/tests/)

[ANTA exit codes](https://anta.arista.com/stable/cli/overview/#anta-exit-codes)


### ENV vars setup

- Contents of .env file

  ```
  export ANTA_USERNAME=ansible
  export ANTA_PASSWORD=ansible
  export ANTA_INVENTORY=ANTA/anta_inventory.yml
  export ANTA_CATALOG=ANTA/anta_catalog.yml
  ```
  source .devcontainer/.env && echo "✅ loaded .env"

- OR modify devcontainer.json to autoload
  
  ```
  "runArgs": ["--env-file",".devcontainer/.env"]
  ```

  contents of .env file
  ```
  ANTA_USERNAME=ansible
  ANTA_PASSWORD=ansible
  ANTA_INVENTORY=ANTA/anta_inventory.yml
  ANTA_CATALOG=ANTA/anta_catalog.yml
  ```

- Load these whenever you want to load your env vars

- Verify they have been loaded

  `printenv | grep ANTA`

### ANTA runner

[anta_runner documentation](https://avd.arista.com/5.7/ansible_collections/arista/avd/roles/anta_runner/)


- Playbook config 

  ```
    - name: Validate Deployment via ANTA
      tags:
        - validate
      ansible.builtin.import_role:
        name: arista.avd.anta_runner
      vars:
        avd_catalogs_filters:
          - skip_tests: [ VerifyNTP ]
          - device_list: "{{ groups['CA1'] }}" 
            skip_tests: [ VerifyReachability, VerifyLoggingErrors ]
          - device_list: [ "CA2-LEAF1A", "CA2-LEAF2A" ] 
            run_tests: [ VerifyLLDPNeighbors]
        avd_catalogs_allow_bgp_vrfs: true
        anta_report_hide_statuses: [ success, skipped ]
        # avd_catalogs_enabled: false 
        # anta_runner_tags: [ clab ]
  ```
- from the above config, `avd_catalogs_filters:` Filters are used to run or skip tests from the AVD-generated catalogs. These filters do not apply to user-defined catalogs, use `anta_runner_tags`
- with `avd_catalogs_enabled: false`, playbook will ONLY run user_catalogs - supply a custom catalog here
- with `avd_catalogs_enabled: true`, playbook will both user_catalogs and avd_catalogs - this is the default
- set `anta_runner_tags` if you have tags set. does not seem to work since the avd_catalog tests is extracting info from inventory
- anta_runner generates the directories
  - {$PWD}/anta
  - {$PWD}/anta/avd_catalogs
  - {$PWD}/anta/user_catalogs
  - {$PWD}/anta/reports


### Workflow

1. Generate Device specific catalog. AVD now uses ANTA to do eos_validate_state. Run `make validate`.

   This generates test catalogs in `intended/test_catalogs`. The device specific catalogs are derived from `intended/structured_configs`.

2. Run `python ANTA/merge_catalogs.py` to merge the device specific catalogs into one big `anta_catalog_merged.yml`
   may need to make changes to individual catalog files generates from before merging.
   eg:

   - `VerifyRoutingTableEntry`
   - `VerifyReachability`: For example for CA1-LEAF1A, you may need to disable tests for reachability to 10.3.1.1/10.4.1.1 from loopback0 ips

3. You can make changes to the devices specific catalogs before merging or make changes to the merged catalog
4. You can run anta against the merged catalog - You can also use a filter via "--device" or "--tags"

   eg `anta nrfu --device CA1-LEAF1A --hide success`




### NRFU without env vars

```
anta nrfu -u ansible --prompt -i ANTA/anta_inventory_auto.yml -c ANTA/anta_catalog.yml

anta nrfu -u ansible -p ansible -i ANTA/anta_inventory_auto.yml -c ANTA/anta_catalog.yml
anta nrfu -u ansible -p ansible -i ANTA/anta_inventory_auto.yml -c ANTA/anta_catalog.yml json
anta nrfu -u ansible -p ansible -i ANTA/anta_inventory_auto.yml -c ANTA/anta_catalog.yml text
```

OR prompt for password

```
anta nrfu --username ansible --prompt -i anta/anta_inventory.yml -c  anta/anta_catalog.yml --hide success --hide skipped
```

Run ANTA using a template<br>

```
anta nrfu  --tags CA1-LEAF1A tpl-report --template ANTA/template.j2
```

### NRFU with ENV vars set:

anta assigns a device tag under the hood, this is in addition to the user defined tags

```
anta nrfu
anta nrfu json
anta nrfu text
anta nrfu md-report --md-output ANTA/reports/nrfu.md

anta get tags


anta nrfu --device CA1-LEAF1A

anta nrfu --test VerifyEOSVersion

anta nrfu --device CA1-LEAF1A
anta nrfu --device CA1-LEAF1A --hide success
```

Group by device <br>
`anta nrfu table --group-by device`

CSV output <br>
`anta nrfu csv --csv-output ANTA/outputs/demo.csv`

Template <br>
`anta nrfu --tags CA1-LEAF1A tpl-report --template ANTA/template.j2`
`anta nrfu --tags CA1-LEAF1A tpl-report --template ANTA/template.j2 --output ANTA/outputs/nrfu-tpl-report.txt`

Dry run <br>
`anta nrfu --dry-run`

Creating an inventory from multiple containers<br>
`for container in pod01 pod02 spines; do anta get from-cvp -ip 10.18.155.202 -u ansible -p ansible -c $container -d test-inventory; done`

Create an Inventory from CloudVision<br>
`anta get from-cvp -ip 10.18.155.202 -u ansible -p ansible -c $container -d test-inventory`

Create an Inventory from Ansible inventory<br>
`anta get from-ansible --ansible-inventory inventory.yml -o ANTA/anta_inventory_auto.yml`

Get Inventory Info<br>
`anta get inventory`
`anta get inventory --tags CA1-LEAF1A, CA1-LEAF1B`

Retrieving Tests information<br>
`anta get tests --module anta.tests.routing.bgp`
`anta get tests --test VerifyBGPPeerCount`

Retrieving Tests information providing prefix<br>
`anta get tests --test VerifyBGP`

Count tests<br>
`anta get tests --count`

Need anta 1.4 to run anta get commands
To retrieve all the commands from the tests<br>
`anta get commands --module anta.tests.routing.bgp`

Filtering using --test <br>
`anta get commands --test VerifyBGPPeerCount`

Filtering using prefix <br>
`anta get commands --test VerifyBGPPeer`

To retrieve all the commands from the tests in a catalog<br>
`anta get commands --catalog ANTA/anta_catalog.yml`

Output using --unique<br>
`anta get commands --catalog ANTA/anta_catalog.yml --unique`

Checking the catalog<br>
`anta check catalog --catalog ANTA/anta_catalog.yml`

ANTA debug commands - Executing an EOS command<br>
`anta debug run-cmd --command "show interfaces description" --device CA1-LEAF1A`

Executing an EOS command using templates<br>
`anta debug run-template --template "show vlan {vlan_id}" vlan_id 110 --device CA1-LEAF1A`

Example of multiple arguments

```
anta -l DEBUG debug run-template --template "ping {dst} source {src}" dst "10.0.0.1" src Port-Channel1 --device HOST1

anta -l DEBUG debug run-template --template "ping {dst} source {src}" dst "10.0.0.1" src Port-Channel1 dst "10.0.0.0" src Port-Channel1 --device HOST1     
```

env vars to set in .env

```
ANTA_USERNAME=ansible
ANTA_PASSWORD=ansible
ANTA_INVENTORY=ANTA/anta_inventory.yml
ANTA_CATALOG=ANTA/anta_catalog.yml

ANTA_INVENTORY=ANTA/anta_inventory_auto.yml
ANTA_CATALOG=ANTA/anta_catalog_merged.yml


export ANTA_USERNAME=ansible
export ANTA_PASSWORD=ansible
export ANTA_INVENTORY=ANTA/anta_inventory.yml
export ANTA_CATALOG=ANTA/anta_catalog.yml

```

### EXEC Commands

Clear interfaces counters
`anta exec clear-counters --tags CA1-LEAF1A`

Collect a set of commands
`anta exec snapshot --tags CA1-LEAF1A --commands-list ANTA/eos_commands.yml -o ANTA/eos_commands_output`

anta exec clear-counters -u ansible --prompt -i ANTA/anta_inventory.yml --tags CA1-LEAF1A

Get Scheduled tech-support
`anta exec collect-tech-support -o ANTA/tech-support --latest 1 --insecure --tags CA1-LEAF1A`

### Python runners

Run anta using python - Basic usage in a Python script<br>
`python ANTA/anta_runner.py`

Run ANTA by supplying eos commands<br>
`python ANTA/run_eos_commands.py`

connects to devices and disconnects to validate the devices are online<br>
`python ANTA/parse_anta_inventory_file.py`

Example script to merge catalogs
`python ANTA/merge_catalogs.py`

### Shell Completion

You can enable shell completion for the ANTA CLI:
If you use ZSH shell, add the following line in your ~/.zshrc:

`eval "$(_ANTA_COMPLETE=zsh_source anta)" > /dev/null`

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Anta Notes

- Filename: [`ANTA Notes`](../../../../../configlets/ANTA_notes.txt)


### Device Inventory

- Filename: [`anta_inventory.yml`](./anta_inventory.yml)
  The file [anta_inventory.yml](anta_inventory.yml) is an example of [device inventory](https://anta.arista.com/stable/usage-inventory-catalog/#create-an-inventory-file).

- Parse an avd inventory file to create anta inventory
  `anta get from-ansible --ansible-inventory inventory.yml -o ANTA/anta_inventory_auto.yml`

### Test Device Connectivity

- Connects to devices and disconnects to validate the devices are online
  `python ANTA/parse_anta_inventory_file.py`

### Test Catalog

- Filename: [`anta_catalog.yml`](./anta_catalog.yml)

The file [anta_catalog.yml](anta_catalog.yml) is an example of a [test catalog](https://anta.arista.com/stable/usage-inventory-catalog/#test-catalog).
This file should contain all the tests implemented in [anta.tests](../anta/tests) with arbitrary parameters.

### Commands to get from snapshot

- Filename: [`eos_commands.yml file`](./eos_commands.yml)

The file [eos_commands.yml](eos_commands.yml) is an example of input given with the `--commands-list` option to the [anta exec snapshot](https://anta.arista.com/stable/cli/exec/#collect-a-set-of-commands) command.

### ANTA runner in Python

- Filename: [`anta_runner.py`](./anta_runner.py)

The file is an example demonstrating how to run ANTA using a Python script.

- Example command to run: [`python ANTA/anta_runner.py`]

### ANTA template for results rendering

- Filename: [`template.j2`](./template.j2)

This file is a simple Jinja2 file to customize ANTA CLI output as documented in [cli documentation](https://anta.arista.com/stable/cli/nrfu/#performing-nrfu-with-custom-reports).

- Example command to run: [`anta nrfu --tags CA1-LEAF1A tpl-report --template ANTA/template.j2`]

### Merge multiple catalogs

- Filename: [`merge_catalogs.py`](./merge_catalogs.py)

This file is an example demonstrating how to merge multiple catalogs into a single catalog and save it to a file, as documented in [usage test catalog](https://anta.arista.com/stable/usage-inventory-catalog/#example-script-to-merge-catalogs).

- Example command to run: [`python ANTA/merge_catalogs.py`]

### Run multiple commands

- Filename: [`run_eos_commands.py`](./run_eos_commands.py)

This file is an example demonstrating how to run multiple commands on multiple devices, as documented in [advanced usages](https://anta.arista.com/stable/advanced_usages/as-python-lib/#run-eos-commands).

- Example command to run: [`python ANTA/run_eos_commands.py`]

### Parse ANTA inventory file

- Filename: [`parse_anta_inventory_file.py`](./parse_anta_inventory_file.py)

This file is an example demonstrating how to parse an ANTA inventory file, as documented in [advanced usages](https://anta.arista.com/stable/advanced_usages/as-python-lib/#parse-anta-inventory-file).

- Example command to run: [`python ANTA/parse_anta_inventory_file.py`]

### Writing Custom ANTA tests

https://gitlab.aristanetworks.com/nate.shaw/anta-playground/

Custom ANTA Test: VerifyInterfaceVLANs
This repository demonstrates how to create and execute a custom ANTA test using the Arista Network Test Automation (ANTA) framework. The included test validates that specified VLANs are correctly configured on specified interfaces using EOS command output.
