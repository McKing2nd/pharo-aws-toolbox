Class {
	#name : #AWSEC2Service,
	#superclass : #Object,
	#instVars : [
		'host',
		'httpClient'
	],
	#category : #'AWS-EC2InstanceMetadata'
}

{ #category : #initialization }
AWSEC2Service >> createHttpClient [
	^ZnClient new
		loggingOff;
		systemPolicy;
		enforceHttpSuccess: false;
		enforceAcceptContentType: false;
		yourself
		
]

{ #category : #resources }
AWSEC2Service >> credentialsUrl [
	^ZnUrl fromString: self host, '/latest/meta-data/iam/security-credentials/'
]

{ #category : #resources }
AWSEC2Service >> dynamicdataUrl [
	^self host,  '/latest/dynamic'
]

{ #category : #internal }
AWSEC2Service >> executeRequest: aRequest [
	
	self getSecurityToken 
		ifNotNil:
			[ :token | aRequest headers at: AWSHeaders x_aws_ec2_metadata_token put: token ].

	^self httpClient
		request: aRequest;
		execute;
		response
]

{ #category : #api }
AWSEC2Service >> getAmiAncestorAmiIds [

	^self getMetadata: '/ancestor-ami-ids'
]

{ #category : #api }
AWSEC2Service >> getAmiId [

	^self getMetadata: 'ami-id'
]

{ #category : #api }
AWSEC2Service >> getAmiLaunchIndex [

	^self getMetadata: 'ami-launch-index'
]

{ #category : #api }
AWSEC2Service >> getAmiManifestPath [

	^self getMetadata: 'ami-manifest-path'
]

{ #category : #api }
AWSEC2Service >> getAvailabilityZone [

	^self getMetadata: 'placement/availability-zone'
]

{ #category : #api }
AWSEC2Service >> getCredentials [
	"self new getCredentials"

	| role |
	role := self getRole.
	role ifNil: [ ^ nil ].
	
	^self getData: self credentialsUrl / role
]

{ #category : #internal }
AWSEC2Service >> getData: anUrl [
	| request response |
	
	request := ZnRequest get: anUrl.
	
	response := self executeRequest: request.
		
	response isSuccess ifFalse: [ ^nil ].
	
	^response contents
]

{ #category : #internal }
AWSEC2Service >> getDynamicdata: aString [

	^self getData: self metadataUrl / aString
]

{ #category : #api }
AWSEC2Service >> getIAMInstanceProfileInfo [
	|json|
	json := self getMetadata: 'iam/info'.
	
	^AWSIAMInfo fromJsonString: json
]

{ #category : #api }
AWSEC2Service >> getInstanceAction [

	^self getMetadata: 'instance-action'
]

{ #category : #api }
AWSEC2Service >> getInstanceId [

	^self getMetadata: 'instance-id'
]

{ #category : #api }
AWSEC2Service >> getInstanceInfo [
	|json|
	json := self getDynamicdata: 'instance-identity/document'.
	
	^AWSEC2InstanceInfo fromJsonString: json
]

{ #category : #api }
AWSEC2Service >> getInstanceRegion [
	^ self getInstanceInfo region
]

{ #category : #api }
AWSEC2Service >> getInstanceSignature [

	^self getDynamicdata: 'innstance-identity/signature'
]

{ #category : #api }
AWSEC2Service >> getInstanceType [

	^self getMetadata: 'instance-type'
]

{ #category : #api }
AWSEC2Service >> getLocalHostName [

	^self getMetadata: 'local-hostname'
]

{ #category : #api }
AWSEC2Service >> getMacAddress [

	^self getMetadata: 'mac'
]

{ #category : #internal }
AWSEC2Service >> getMetadata: aString [
	^ self getData: self metadataUrl / aString
]

{ #category : #api }
AWSEC2Service >> getPrivateIpAddress [

	^self getMetadata: 'local-ipv4'
]

{ #category : #api }
AWSEC2Service >> getProductCodes [

	^self getMetadata: 'product-codes'
]

{ #category : #api }
AWSEC2Service >> getPublicKey [

	^self getMetadata: 'public-keys/0/openssh-key'
]

{ #category : #api }
AWSEC2Service >> getRamdiskId [

	^self getMetadata: 'ramdisk-id'
]

{ #category : #api }
AWSEC2Service >> getReservationId [

	^self getMetadata: 'reservation-id'
]

{ #category : #api }
AWSEC2Service >> getRole [
	
	^self getData: self credentialsUrl
]

{ #category : #api }
AWSEC2Service >> getSecurityGroups [

	^self getMetadata: 'security-groups'
]

{ #category : #api }
AWSEC2Service >> getSecurityToken [
	"self new getSecurityToken"
	| request response |
	
	request := ZnRequest put: self tokenUrl.
	request headers at: AWSHeaders x_aws_ec2_metadata_token_ttl_seconds put: '21600'.
	
	response := self httpClient request: request; execute; response.
	
	response isSuccess ifFalse: [ ^nil ].
	
	^response contents
]

{ #category : #resources }
AWSEC2Service >> host [

	^host ifNil: [ host := 'http://169.254.169.254' ]
]

{ #category : #accessing }
AWSEC2Service >> httpClient [

	^httpClient ifNil: [ httpClient := self createHttpClient ] 
]

{ #category : #resources }
AWSEC2Service >> metadataUrl [
	^ZnUrl fromString: self host, '/latest/meta-data/'
]

{ #category : #resources }
AWSEC2Service >> tokenUrl [
	^self host, '/latest/api/token'
]

{ #category : #resources }
AWSEC2Service >> userdataUrl [
	^self host,  '/latest/user-data'
]
