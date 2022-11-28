//
//  ASNPayloadDecoder.swift
//  ASNViewer
//
//  Created by nanashiki on 2022/11/29.
//

import Foundation
import JOSESwift

enum ASNPayloadDecoder {
    static func decode(signedPayload: String) throws -> ServerNotification {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .millisecondsSince1970

        let jws = try JWS(compactSerialization: signedPayload)
        let x5c = jws.header.x5c!
            .map {
                Data(base64URLEncoded: $0)!
            }
            .map {
                SecCertificateCreateWithData(nil, $0 as CFData)
            }

        let policy = SecPolicyCreateBasicX509()
        var optionalTrust: SecTrust?
        let status = SecTrustCreateWithCertificates(
            x5c as AnyObject,
            policy,
            &optionalTrust
        )
        guard status == errSecSuccess else {
            exit(1)
        }
        let trust = optionalTrust!

        let verifier = Verifier(
            verifyingAlgorithm: jws.header.algorithm!,
            key: SecTrustCopyKey(trust)!
        )!
        let payload = try jws.validate(using: verifier).payload

        let notification = try jsonDecoder.decode(ServerNotificationReponse.self, from: payload.data())

        let signedTransactionInfoJws = try JWS(
            compactSerialization: notification.data.signedTransactionInfo
        )
        let signedRenewalInfoJws = try JWS(compactSerialization: notification.data.signedRenewalInfo)

        let transactionInfoReponse = try jsonDecoder.decode(
            TransactionInfoReponse.self,
            from: signedTransactionInfoJws.payload.data()
        )
        let renewalInfoReponse = try jsonDecoder.decode(
            RenewalInfoReponse.self,
            from: signedRenewalInfoJws.payload.data()
        )

        return ServerNotification(
            notificationType: notification.notificationType,
            subtype: notification.subtype,
            notificationUUID: notification.notificationUUID,
            version: notification.version,
            bundleId: notification.data.bundleId,
            bundleVersion: notification.data.bundleVersion,
            environment: notification.data.environment,
            transactionInfo: TransactionInfo(
                transactionId: transactionInfoReponse.transactionId,
                originalTransactionId: transactionInfoReponse.originalTransactionId,
                webOrderLineItemId: transactionInfoReponse.webOrderLineItemId,
                productId: transactionInfoReponse.productId,
                subscriptionGroupIdentifier: transactionInfoReponse.subscriptionGroupIdentifier,
                purchaseDate: transactionInfoReponse.purchaseDate,
                originalPurchaseDate: transactionInfoReponse.originalPurchaseDate,
                expiresDate: transactionInfoReponse.expiresDate,
                quantity: transactionInfoReponse.quantity,
                type: transactionInfoReponse.type,
                appAccountToken: transactionInfoReponse.appAccountToken,
                inAppOwnershipType: transactionInfoReponse.inAppOwnershipType
            ),
            renewalInfo: RenewalInfo(
                expirationIntent: renewalInfoReponse.expirationIntent,
                originalTransactionId: renewalInfoReponse.originalTransactionId,
                autoRenewProductId: renewalInfoReponse.autoRenewProductId,
                productId: renewalInfoReponse.productId,
                autoRenewStatus: renewalInfoReponse.autoRenewStatus,
                isInBillingRetryPeriod: renewalInfoReponse.isInBillingRetryPeriod,
                environment: renewalInfoReponse.environment,
                recentSubscriptionStartDate: renewalInfoReponse.recentSubscriptionStartDate
            )
        )
    }
}

struct ServerNotificationReponse: Decodable {
    struct Data: Decodable {
        let bundleId: String
        let bundleVersion: String
        let environment: String
        let signedTransactionInfo: String
        let signedRenewalInfo: String
    }
    let notificationType: String
    let subtype: String?
    let notificationUUID: UUID
    let data: Data
    let version: String
    let signedDate: Date?
}

struct RenewalInfoReponse: Decodable {
    let expirationIntent: Int?
    let originalTransactionId: String
    let autoRenewProductId: String
    let productId: String
    let autoRenewStatus: Int
    let isInBillingRetryPeriod: Bool?
    let signedDate: Date?
    let environment: String
    let recentSubscriptionStartDate: Date?
}

struct TransactionInfoReponse: Decodable {
    let transactionId: String
    let originalTransactionId: String
    let webOrderLineItemId: String
    let bundleId: String
    let productId: String
    let subscriptionGroupIdentifier: String
    let purchaseDate: Date
    let originalPurchaseDate: Date
    let expiresDate: Date
    let quantity: Int
    let type: String
    let appAccountToken: String?
    let inAppOwnershipType: String
    let signedDate: Date?
    let environment: String
}
