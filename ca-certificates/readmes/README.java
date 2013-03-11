This directory /etc/pki/ca-trust/extracted/java/ contains 
CA certificate bundle files which are automatically created
based on the information found in the
/usr/share/pki/ca-trust-source/ and /etc/pki/ca-trust/source/
directories.

All files are in the java keystore file format.

Distrust information cannot be represented in this file format,
and distrusted certificates are missing from these files.

File cacerts contains CA certificates 
trusted for TLS server authentication.

If your application isn't able to load the PKCS#11 module p11-kit-trust.so,
then you can use these files in your application to load a list of global
root CA certificates.

Please never manually edit the files stored in this directory,
because your changes will be lost and the files automatically overwritten,
each time the update-ca-trust command gets executed.

In order to install new trusted or distrusted certificates,
please rather install them in the 
/usr/share/pki/ca-trust-source/ and /etc/pki/ca-trust/source/
directories.

Please refer to the README files in those directories to learn
how to install new files.
