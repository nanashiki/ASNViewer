//
//  ServerNotification.swift
//  ASNViewer
//
//  Created by nanashiki on 2022/11/29.
//

import Foundation

struct ServerNotification {
    let notificationType: String
    let subtype: String?
    let notificationUUID: UUID
    let version: String
    let bundleId: String
    let bundleVersion: String
    let environment: String
    let transactionInfo: TransactionInfo
    let renewalInfo: RenewalInfo
}

struct TransactionInfo {
    let transactionId: String
    let originalTransactionId: String
    let webOrderLineItemId: String
    let productId: String
    let subscriptionGroupIdentifier: String
    let purchaseDate: Date
    let originalPurchaseDate: Date
    let expiresDate: Date
    let quantity: Int
    let type: String
    let appAccountToken: String?
    let inAppOwnershipType: String
}

struct RenewalInfo {
    let expirationIntent: Int?
    let originalTransactionId: String
    let autoRenewProductId: String
    let productId: String
    let autoRenewStatus: Int
    let isInBillingRetryPeriod: Bool?
    let environment: String
    let recentSubscriptionStartDate: Date?
}
