# Challenge 3: Setup the DNS Proxy

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-acr.md)

## Introduction

In this challenge, you will set up DNS queries coming from the virtual machines to the Azure Firewall that will act as DNS Proxy.


## Description
You will set up the DNS Proxy through the Azure Firewall, and when virtual machines try to resolve domain names, the first step these requests will be following to Firewall base on virtual network DNS settings. 

#### Task 1 - Enabling the DNS Proxy

To start the setup, follow the steps listed below:

1. Login to Azure Portal [https://portal.azure.com/](https://portal.azure.com/)
    - To start Azure Cloud Shell:
        - Select the Cloud Shell button on the menu bar at the upper right in the Azure portal. 

    ![Menu](images/hdi-cloud-shell-menu.png)

2. Ensure you are properly logged in to your tenant and with a subscription selected for Azure. You can check that by using:

```azure cli
az account list --output table
az account set --subscription "My Subscription"
```

- Setup the DNS Proxy trought Firewall Policy  **azfw-policy-std**, and using the Azure Cloud Shell

```bash
az network firewall policy update --name azfw-policy-std -g wth-azurefirewall-rg --enable-dns-proxy --sku Premium
```

- Connect to **azbrazilsouthvm01 - 10.20.1.4** via Bastion, open the command prompt and run it:

```cmd
nslookup www.microsoft.com
```

- Look at the information and verify the **address** of the DNS Server.

:question:What is the DNS Ip Address?

You will change the DNS Server in the spoke virtual network and verify the DNS IP address inside the virtual machine.

```bash
az network vnet update -g wth-azurefirewall-rg  -n brazilsouth-spoke1-vnet --dns-servers 10.200.3.4
```

- Connect again to **azbrazilsouthvm01 - 10.20.1.4** via Bastion, open the command prompt and run it:

```cmd
ipconfig /release && ipconfig /renew
```

Wait to the Azure Bastion to reconnect the virtual machine and run it:

```cmd
nslookup www.microsoft.com
```

:question:What is the DNS IP Address?

You can verify if it triggers an alert in the Azure Log Analytics. You can use the below Kusto Query:

```bash
AzureDiagnostics
| where Category == "AzureFirewallDnsProxy" and msg_s contains "www.microsoft.com"
| parse msg_s with "DNS Request: " SourceIP ":" SourcePortInt:int " - " QueryID:int " " RequestType " " RequestClass " " hostname ". " protocol " " details
| extend
    ResponseDuration = extract("[0-9]*.?[0-9]+s$", 0, msg_s),
    SourcePort = tostring(SourcePortInt),
    QueryID =  tostring(QueryID)
| project TimeGenerated,SourceIP,hostname,RequestType,ResponseDuration,details,msg_s
| order by TimeGenerated
| limit 5
```

:question: What is the result?

## Success Criteria

1. You have updated the Firewall policy with the application rule
2. You have updated the DNS Proxy.
3. You can see the DNS queries to the following for Azure Firewall.


## Learning Resources

- [Azure Firewall DNS settings](https://docs.microsoft.com/en-us/azure/firewall/dns-settings)</br>
- [Name resolution for resources in Azure virtual networks](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances)

