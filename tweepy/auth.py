#!/usr/bin/env python

import tweepy

CONSUMER_KEY = 'unEsf6mbpT6bibH6Y8zAL0iZC'
CONSUMER_SECRET = 'FStxh0vZ2DxmWWE40u0fRl0cVO9n1DR76fvxpTiFF3RRqI9VCT'

auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.secure = True
auth_url = auth.get_authorization_url()
print 'Please authorize: ' + auth_url
verifier = raw_input('PIN: ').strip()
auth.get_access_token(verifier)
print "ACCESS_KEY = '%s'" % auth.access_token.key
print "ACCESS_SECRET = '%s'" % auth.access_token.secret
