// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("account_event_stream")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("account_event_stream", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "account_opened",
                    "ledger_entry_posted"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "ledger_entry"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("account_event_stream").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "account_opened",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "ledger_entry",
            "key": {
                "id": 3001
            },
            "snapshot": {
                "id": 3001,
                "account_id": 2001,
                "entry_type": "debit",
                "amount": 25.5,
                "posted_at": "2026-10-05T12:15:00Z",
                "external_ref": "EXT-SYN-001"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "id": 2001
                    },
                    "via": [
                        "ledger_entry.account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "ledger_entry_posted",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "ledger_entry",
            "key": {
                "id": 3001
            },
            "snapshot": {
                "id": 3001,
                "account_id": 2001,
                "entry_type": "debit",
                "amount": 25.5,
                "posted_at": "2026-10-05T12:15:00Z",
                "external_ref": "EXT-SYN-001"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "id": 2001
                    },
                    "via": [
                        "ledger_entry.account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "metadata": "illustrative metadata",
                "provider_payload": "illustrative provider_payload"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "account_opened",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "ledger_entry",
            "key": {
                "id": 3002
            },
            "snapshot": {
                "id": 3002,
                "account_id": 2002,
                "entry_type": "credit",
                "amount": 100,
                "posted_at": "2026-10-06T14:45:00Z",
                "external_ref": null
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "id": 2002
                    },
                    "via": [
                        "ledger_entry.account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "ledger_entry_posted",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "ledger_entry",
            "key": {
                "id": 3002
            },
            "snapshot": {
                "id": 3002,
                "account_id": 2002,
                "entry_type": "credit",
                "amount": 100,
                "posted_at": "2026-10-06T14:45:00Z",
                "external_ref": null
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "id": 2002
                    },
                    "via": [
                        "ledger_entry.account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "metadata": "illustrative metadata",
                "provider_payload": "illustrative provider_payload"
            }
        }
    }
]));
  await db.getCollection("account_event_stream").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("account_event_stream").find({"eventType":"account_opened"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("account_event_stream").find({"source.key.id":3001}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("account_event_stream").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("account_event_stream").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("account_event_stream").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "account_opened",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "ledger_entry",
        "key": {
            "id": 3001
        },
        "snapshot": {
            "id": 3001,
            "account_id": 2001,
            "entry_type": "debit",
            "amount": 25.5,
            "posted_at": "2026-10-05T12:15:00Z",
            "external_ref": "EXT-SYN-001"
        }
    },
    "embedded": {},
    "references": {
        "account": [
            {
                "key": {
                    "id": 2001
                },
                "via": [
                    "ledger_entry.account_id → account"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("account_event_stream").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "account_opened",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "ledger_entry",
        "key": {
            "id": 3001
        },
        "snapshot": {
            "id": 3001,
            "account_id": 2001,
            "entry_type": "debit",
            "amount": 25.5,
            "posted_at": "2026-10-05T12:15:00Z",
            "external_ref": "EXT-SYN-001"
        }
    },
    "embedded": {},
    "references": {
        "account": [
            {
                "key": {
                    "id": 2001
                },
                "via": [
                    "ledger_entry.account_id → account"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("account_event_stream").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
