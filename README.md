
<p align="center">
  <img src="/Student/images/wth_hack.png" width=350/>
</p>
# What The Hack - Protect your vNETs with Azure Firewall Premium
## Introduction
The adoption of Internet use throughout the business world has boosted network usage in general. Companies are using various network security measures such as firewalls, intrusion detection systems (IDS), intrusion prevention systems (IPS) to protect their networks (even for cloud computing), which are the preferred targets of threat actors for compromising organizations’ security. The Azure Firewall is a managed, cloud-based network security service that protects your resources inside the virtual network. You will engage in a complex Azure Network security setup using the Azure Firewall to complete the challenges in these WTH exercises. You will set up rules for Network, Application, IDPs, Threat Intel, TLS Inspection and Web Categories.


<p align="center">
  <img width="500" height="420" src="/Student/images/firewall-threat.jpg">
</p>


This hack includes a optional [lecture presentation](Coach/Lectures.pptx) that features short presentations to introduce key topics associated with Azure Firewall Premium. It is recommended that the host present each short presentation before attendees kick off that challenge.
## Learning Objectives

After completing this Hack you will be able to:

- How to implement Azure Firewall and Firewall Manager to control hybrid and cross-virtual network traffic.
- How to implement the Azure Sentinel to monitoring and generated security incident alerts.
- How to detect malicious network attack.
- How to set up policies rules on Azure Firewall Premium.

## Challenges
- Challenge 0: **[Prerequisites!](Student/00-prereqs.md)**
   - Prepare your enviroment on Azure with terraform and Az Cli code.
- Challenge 1: **[Intra-region Forwarding](Student/01-intra-forwarding.md)**
   - Establish the communication between two spokes virtual networks through Azure Firewall in the same region.
- Challenge 2: **[Inter-region Forwarding](Student/02-inter-forwarding.md)**
   - Establish the communication between two spokes virtual networks through Azure Firewall in the different regions.
- Challenge 3: **[Threat Intelligence](Student/03-threat-intelligence.md)**
   - Setup the Thread Intelligence and verify it is running.
- Challenge 4: **[DNS Proxy](Student/04-dns-proxy.md)**
   -  Configure all forward DNS from virtual networks to Azure Firewall.
- Challenge 5: **[IDPS](Student/05-idps.md)**
   - Configure a network intrusion detection and prevention system (IDPS) that allows you to monitor network activities for malicious activity.
- Challenge 6: **[TLS Inspection](Student/06-tls-inspection.md)**
   - Configure the TLS inspection to decrypts/encrypts outbound data traffic.
- Challenge 7: **[URL Filtering](Student/07-url-filtering.md)**
   - Configure the URL Filtering in the application rule .
- Challenge 8: **[Web Categories](Student/08-web-categories.md)**
   - Manager the web categories to allow or deny the user access.
- Challenge 9: **[Enabling the Azure Firewall solution for Azure Sentinel (Optional) ](Student/08-web-categories.md)**
   - Deploy a Firewall solution inside the Azure Sentinel to have visibility of the netowrk security incidents.

## Prerequisites

The purpose of this Hack is to build an understanding of the use of Azure Firewall with a focus on the network and security capabilities recently introduced. Consider the following articles required as pre-reading to build a foundation of knowledge.


- `1.2.2 Azure Firewall and Azure Firewall Manager`
   - [Azure Network Security Ninja Training ](https://techcommunity.microsoft.com/t5/azure-network-security/azure-network-security-ninja-training/ba-p/2356101)

## Repository Contents
- `../Coach/Guides`
  - [Lecture presentation](Coach/Lectures.pptx) with short presentations to introduce the Azure Firewall.
- `../Coach/Solutions`
   - Example solutions to the challenges (If you're a student, don't cheat yourself out of an education!)
- `../Student/Resources`
   - Terraform code to build the enviroment and sample templates to aid with challenges.

## Contributors
- Adilson Coutrin
- Flavio Honda
