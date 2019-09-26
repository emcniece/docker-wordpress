<?php

/**
 * Register the master server to HyperDB
 */
$wpdb->add_database( array(
  'host'     => DB_HOST, // If port is other than 3306, use host:port
  'user'     => DB_USER,
  'password' => DB_PASSWORD,
  'name'     => DB_NAME,
  'write'    => 1, // master server takes write queries
  'read'     => 0, // ... and read queries
) );

/**
 * Register replica database server if it's available in this environment
 */
if ( ! empty( $_ENV['REPLICA_DB_HOST'] ) ) {
  $wpdb->add_database(array(
    'host'     => $_ENV['REPLICA_DB_HOST'] . ':' . $_ENV['REPLICA_DB_PORT'],
    'user'     => $_ENV['REPLICA_DB_USER'],
    'password' => $_ENV['REPLICA_DB_PASSWORD'],
    'name'     => $_ENV['REPLICA_DB_NAME'],
    'write'    => 0, // replica doesn't take write queries
    'read'     => 1, // ... but it does take read queries
  ));
}