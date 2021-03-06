Class {
	#name : #AWSSQSMessage,
	#superclass : #AWSXmlObject,
	#instVars : [
		'messageXml'
	],
	#category : #'AWS-SimpleQueueService'
}

{ #category : #accessing }
AWSSQSMessage >> attributeAt: aName [
	self messageXml elementsAt: 'Attribute' do: [ :each |
		| attrib |
		attrib := AWSSQSAttribute fromXmlElement: each.
		attrib name = aName
			ifTrue: [ ^ attrib value ] ].
	^ nil
]

{ #category : #accessing }
AWSSQSMessage >> attributes [
	^ ((self messageXml elementsAt: 'Attribute')
			collect: [ :each | AWSSQSAttribute fromXmlElement: each ]) asArray
]

{ #category : #accessing }
AWSSQSMessage >> body [
	^ self messageXml contentStringAt: 'Body'
]

{ #category : #initialization }
AWSSQSMessage >> initFromXmlElement: msgElement [
	messageXml := msgElement 
]

{ #category : #accessing }
AWSSQSMessage >> md5OfBody [ 
	^ self messageXml contentStringAt: 'MD5OfBody'
]

{ #category : #accessing }
AWSSQSMessage >> messageAttributeAt: aName [
	self messageXml elementsAt: 'MessageAttribute' do: [ :each |
		| attrib |
		attrib := AWSSQSMessageAttribute fromXmlElement: each.
		attrib name = aName
			ifTrue: [ ^ attrib value ] ].
	^ nil
]

{ #category : #accessing }
AWSSQSMessage >> messageAttributes [
	^ ((self messageXml elementsAt: 'MessageAttribute')
			collect: [ :each | AWSSQSMessageAttribute fromXmlElement: each ]) asArray
]

{ #category : #accessing }
AWSSQSMessage >> messageId [
	^ self messageXml contentStringAt: 'MessageId'
]

{ #category : #accessing }
AWSSQSMessage >> messageXml [
	^ messageXml
]

{ #category : #accessing }
AWSSQSMessage >> receiptHandle [ 
	^ (self messageXml contentStringAt: 'ReceiptHandle') trimmed
]
