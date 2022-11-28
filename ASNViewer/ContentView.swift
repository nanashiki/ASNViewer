//
//  ContentView.swift
//  ASNViewer
//
//  Created by nanashiki on 2022/11/29.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    @State private var notification: ServerNotification? = nil
    @State private var error: Error? = nil

    var body: some View {
        VStack {
            TextField("JWS Playload (ey...", text: $text)
            Button("変換") {
                notification = nil
                error = nil
                do {
                    notification = try ASNPayloadDecoder.decode(signedPayload: text)
                } catch {
                    print(error)
                    self.error = error
                }
            }
            if let error = error {
                Form {
                    Section {
                        HStack {
                            Text("Verification")
                            Spacer()
                            Text("Error")
                        }
                        HStack {
                            Text("Message")
                            Spacer()
                            Text(error.localizedDescription)
                        }
                    } header: {
                        Text("Result")
                    }
                }
            }
            if let notification = notification {
                Form {
                    Section {
                        HStack {
                            Text("Verification")
                            Spacer()
                            Text("Success")
                        }
                    } header: {
                        Text("Result")
                    }
                    Section {
                        HStack {
                            Text("Notification Type")
                            Spacer()
                            Text(notification.notificationType)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Subtype")
                            Spacer()
                            Text(notification.subtype ?? "")
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Notification UUID")
                            Spacer()
                            Text(notification.notificationUUID.uuidString)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Notification Version")
                            Spacer()
                            Text(notification.version)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("BundleId")
                            Spacer()
                            Text(notification.bundleId)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("bundle Version")
                            Spacer()
                            Text(notification.bundleVersion)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Environment")
                            Spacer()
                            Text(notification.environment)
                                .textSelection(.enabled)
                        }
                    } header: {
                        Text("Basic")
                            .padding(.top, 4)
                    }

                    Section {
                        HStack {
                            Text("Transaction Id")
                            Spacer()
                            Text(notification.transactionInfo.transactionId)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Original Transaction Id")
                            Spacer()
                            Text(notification.transactionInfo.originalTransactionId)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("WebOrder Line Item Id")
                            Spacer()
                            Text(notification.transactionInfo.webOrderLineItemId)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Product Id")
                            Spacer()
                            Text(notification.transactionInfo.productId)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Subscription Group Identifier")
                            Spacer()
                            Text(notification.transactionInfo.subscriptionGroupIdentifier)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Purchase Date")
                            Spacer()
                            Text(string(from: notification.transactionInfo.purchaseDate))
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Original Purchase Date")
                            Spacer()
                            Text(string(from: notification.transactionInfo.originalPurchaseDate))
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Xxpires Date")
                            Spacer()
                            Text(string(from: notification.transactionInfo.expiresDate))
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("appAccountToken")
                            Spacer()
                            Text(notification.transactionInfo.appAccountToken ?? "")
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("inAppOwnershipType")
                            Spacer()
                            Text(notification.transactionInfo.inAppOwnershipType)
                                .textSelection(.enabled)
                        }
                    } header: {
                        Text("Transaction Info")
                            .padding(.top, 4)
                    }

                    Section {
                        HStack {
                            Text("Expiration Intent")
                            Spacer()
                            Text("\(notification.renewalInfo.expirationIntent ?? -1)")
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Original Transaction Id")
                            Spacer()
                            Text(notification.renewalInfo.originalTransactionId)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Auto Renew Product Id")
                            Spacer()
                            Text(notification.renewalInfo.autoRenewProductId)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Product Id")
                            Spacer()
                            Text(notification.renewalInfo.productId)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Auto Renew Status")
                            Spacer()
                            Text("\(notification.renewalInfo.autoRenewStatus)")
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Is In Billing Retry Period")
                            Spacer()
                            Text((notification.renewalInfo.isInBillingRetryPeriod ?? false) ? "YES" : "NO")
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Recent Subscription Start Date")
                            Spacer()
                            Text(
                                notification.renewalInfo.recentSubscriptionStartDate.map { string(from: $0) } ?? ""
                            )
                            .textSelection(.enabled)
                        }
                    } header: {
                        Text("Renewal Info")
                            .padding(.top, 4)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }

    func string(from date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .medium
        return df.string(from: date)
    }
}

#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#endif
