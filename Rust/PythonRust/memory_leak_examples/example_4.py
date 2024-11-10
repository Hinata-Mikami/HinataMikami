# https://stackoverflow.com/questions/2017381/is-it-possible-to-have-an-actual-memory-leak-in-python-because-of-your-code
class User:
    def set_profile(self, profile):
        def on_completed(result):
            if result.success:
                self.profile = profile

        self._db.execute(
            change={'profile': profile},
            on_complete=on_completed
        )
        