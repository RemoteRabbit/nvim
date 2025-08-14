;; python
#!/usr/bin/env python3
"""
{{_file_name_}} - {{_input_:description_}}

Author: {{_author_}}
Date: {{_date_}}
"""

import argparse
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def main():
    """Main function."""
    parser = argparse.ArgumentParser(description="{{_input_:description_}}")
    parser.add_argument("--verbose", "-v", action="store_true", help="Verbose output")
    args = parser.parse_args()

    if args.verbose:
        logging.basicConfig(level=logging.DEBUG)

    {{_cursor_}}


if __name__ == "__main__":
    main()
