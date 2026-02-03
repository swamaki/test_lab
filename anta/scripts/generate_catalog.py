import yaml

# Print the structured output
import pprint

# Load the YAML file
with open("ANTA/scripts/example.yml", "r") as file:
    data = yaml.safe_load(file)


# print(data["tenant_prod"][0]["name"])
# print(data['tenant_prod'][0]['vrfs'][0]['bgp_peers'][0])
# pprint.pprint(data)

# Extract relevant information and structure it
output = {
    "anta.tests.bfd": [
        {
            "VerifyBFDPeersIntervals": {
                "bfd_peers": [
                    {
                        "multiplier": 3,
                        "peer_address": peer["ip_address"],
                        "rx_interval": 1200,
                        "tx_interval": 1200,
                        "vrf": data["tenant_prod"][0]["name"],
                    }
                    for peer in data["tenant_prod"][0]["vrfs"][0]["bgp_peers"]
                ],
                "filters": {"tags": ["edgeswitch01"]},
            }
        },
        {
            "VerifyBFDPeersRegProtocols": {
                "bfd_peers": [
                    {
                        "peer_address": peer["ip_address"],
                        "protocols": ["bgp"],
                        "vrf": data["tenant_prod"][0]["vrfs"][0]["name"],
                    }
                    for peer in data["tenant_prod"][0]["vrfs"][0]["bgp_peers"]
                ],
                "filters": {"tags": ["edgeswitch01"]},
            }
        },
        {
            "VerifyBFDSpecificPeers": {
                "bfd_peers": [
                    {
                        "peer_address": peer["ip_address"],
                        "vrf": data["tenant_prod"][0]["vrfs"][0]["name"],
                    }
                    for peer in data["tenant_prod"][0]["vrfs"][0]["bgp_peers"]
                ],
                "filters": {"tags": ["edgeswitch01"]},
            }
        },
        {"VerifyBFDPeersHealth": {"down_threshold": 2}},
    ],
    # Add other sections similarly...
}


pprint.pprint(output)
