from brownie import network, config, accounts, MockV3Aggregator
from web3 import Web3

LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]


def get_account():
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


def deploy_mocks():
    print(f"The active network is {network.show_active()}")
    print("Deploying Mocks...")
    if len(MockV3Aggregator) <= 0:
        MockV3Aggregator.deploy(
            config["networks"][network.show_active()]["eth_usd_price_decimals"],
            config["networks"][network.show_active()]["starting_price"],
            {"from": get_account()},
        )
    print("Mocks Deployed!")


def get_decimals():
    return config["networks"][network.show_active()]["eth_usd_price_decimals"]
