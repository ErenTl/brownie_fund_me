from brownie import FundMe
from scripts.helpful_scripts import get_account


def fund():
    fund_me = FundMe[-1]
    account = get_account()
    entrance_fee = fund_me.getEntranceFee()
    print("The current entrance fee is ", entrance_fee, " wei")
    print("Funding...")
    fund_me.fund({"from": account, "value": entrance_fee})
    print(
        "Funded! contract's balance is ", fund_me.weiToUSD(fund_me.balance()), " dolar"
    )


def withdraw():
    fund_me = FundMe[-1]
    account = get_account()
    fund_me.withdraw({"from": account})
    print(
        "Withdrawed! contract's balance is ",
        fund_me.weiToUSD(fund_me.balance()),
        " dolar",
    )


def main():
    fund()
    withdraw()
