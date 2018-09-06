"""
Simple extension that adds HTTP Basic authentication to `hg serve`.
Username and password are configured using repository hgrc file:

[web]
# default value: Mercurial
auth.realm=realm
# default value: test
auth.user=username
#default value: test
auth.password=password

NOTE: Only one user/password is allowed although it would be easy to extend to
do so.

NOTE: This extension does not support SSL connections, although it would be easy
to extend it to do so.

WARNING: This **should not** be used for serving mercurial repositories. This
extension is merely intended to allow for easy testing of third-party  libraries
against HTTP-served repositories.

Author: Jan Vrany <jan.vrany (a) fit.cvut.cz>
"""

import mercurial.hgweb.server as hgserve
import mercurial.extensions as hgexts
from base64 import b64encode

class _httpauthenticatedrequesthandler(hgserve._httprequesthandler):
    def realm(self):
        return self.server.ui.config('web', 'auth.realm', 'Mercurial')

    def user(self):
        return self.server.ui.config('web', 'auth.user', 'test')

    def password(self):
        return self.server.ui.config('web', 'auth.password', 'test')

    def secret(self):
        return b64encode("%s:%s" % ( self.user(), self.password() ))

    def do_HEAD(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_AUTHHEAD(self):
        self.send_response(401)
        self.send_header('WWW-Authenticate', 'Basic realm=\"%s\"' % self.realm())
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        if self.headers.getheader('Authorization') == None:
            self.do_AUTHHEAD()
            self.wfile.write('Not authorized')
            pass
        elif self.headers.getheader('Authorization') == ('Basic %s' % self.secret()):
            hgserve._httprequesthandler.do_GET(self)
            pass
        else:
            self.do_AUTHHEAD()
            self.wfile.write('Not authenticated')
            pass

def auth_create_server(create_server, ui, app):
    httpd = create_server(ui, app)
    httpd.ui = ui
    httpd.RequestHandlerClass = _httpauthenticatedrequesthandler
    return httpd

hgexts.wrapfunction(hgserve, 'create_server', auth_create_server)






