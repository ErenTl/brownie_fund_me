from brownie import FundMe, MockV3Aggregator, config, network
from scripts.helpful_scripts import (
    deploy_mocks,
    get_account,
    LOCAL_BLOCKCHAIN_ENVIRONMENTS,
    get_decimals,
)


def deploy_fund_me():
    account = get_account()

    # pass the price feed address to our fundme contract
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        price_feed_address = config["networks"][network.show_active()][
            "eth_usd_price_feed"
        ]
    else:
        # if the network we are using is local network like ganache we
        # deploy mock for price feed
        deploy_mocks()
        price_feed_address = MockV3Aggregator[-1].address

    fund_me = FundMe.deploy(
        price_feed_address,
        get_decimals(),
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify"),
    )

    print(f"Contract deployed to {fund_me.address}")
    print("decimal is ", get_decimals())
    print("price is ", fund_me.getPrice())

    return fund_me


def main():
    deploy_fund_me()
