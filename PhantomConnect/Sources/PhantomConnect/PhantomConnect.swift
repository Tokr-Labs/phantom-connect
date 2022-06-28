public struct PhantomConnect {

    /// Configures the library for use
    /// - Parameters:
    ///   - appUrl: The url of you app that will be used for graph assets.
    ///   - cluster: Solana cluster (e.g. "devnet", "mainnet-beta").
    ///   - redirectUrl: The url scheme base to be used to redirect back to the calling app (e.g. "com.site.app"). Do not include the "://" in the redirect url.
    public static func configure(
        appUrl: String,
        cluster: String,
        redirectUrl: String
    ) {
        PhantomConnectService.appUrl = appUrl
        PhantomConnectService.cluster = cluster
        PhantomConnectService.redirectUrl = redirectUrl
    }
    
}
