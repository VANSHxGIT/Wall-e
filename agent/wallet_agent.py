from web3 import Web3


class AIAgentWallet:
    def __init__(self, rpc_url, private_key, contract_address, abi):
        self.w3 = Web3(Web3.HTTPProvider(rpc_url))
        self.account = self.w3.eth.account.from_key(private_key)
        self.contract = self.w3.eth.contract(address=contract_address, abi=abi)

    def make_micro_settlement(self, to_address, amount_wei):
        """Executes a micro-transaction under the programmable wallet constraints"""
        tx = self.contract.functions.executeTransaction(to_address, amount_wei).build_transaction({
            'from': self.account.address,
            'nonce': self.w3.eth.get_transaction_count(self.account.address),
            'gas': 2000000,
            'gasPrice': self.w3.eth.gas_price
        })
        signed_tx = self.w3.eth.account.sign_transaction(tx, private_key=self.account.key)
        tx_hash = self.w3.eth.send_raw_transaction(signed_tx.rawTransaction)
        return self.w3.eth.wait_for_transaction_receipt(tx_hash)


def main():
    print("AIAgentWallet is ready. Provide rpc_url, private_key, contract_address, and abi to execute transactions.")


if __name__ == "__main__":
    main()

# Example:
# agent = AIAgentWallet('https://testnet-rpc.monad.xyz', '0x...', '0xContract...', abi)
# agent.make_micro_settlement('0xReceiver...', 1000000000000000)
